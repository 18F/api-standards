#! /usr/bin/env ruby

require 'fileutils'
require 'yaml'

module Pages18F
  def self.readme_to_pages(readme_path)
    return unless File.exist? readme_path
    sections = parse_sections File.readlines(readme_path)
    nested_sections = nest_sections sections
    fail RuntimeError unless nested_sections.size == 1
    sections_tree = nested_sections.first
    update_titles sections_tree
    detach_children_from_top_level_element sections_tree
    set_permalinks_and_filenames sections_tree
    config = generate_config(sections_tree)
    pages = generate_pages(sections_tree)
    [config, pages]
  end

  def self.parse_sections(lines)
    sections = []
    title, content, remaining = parse_section lines
    sections << { title: title, content: content }
    until remaining.length == 0
      title, content, remaining = parse_section remaining
      sections << { title: title, content: content }
    end
    sections
  end

  def self.parse_section(lines)
    title = lines[0].rstrip
    i = 1
    content = []
    until lines[i].nil? || lines[i][0] == '#'
      content << lines[i].rstrip
      i += 1
    end
    [title, content, lines[i..lines.length]]
  end

  def self.nest_sections(sections)
    previous = sections.shift
    nested = [previous]
    current = sections.shift
    until current.nil?
      level = section_level current
      parent = previous
      until parent.nil? || section_level(parent) < level
        parent = parent[:parent]
      end

      if parent.nil?
        nested << current
      else
        (parent[:children] ||= []) << current
        current[:parent] = parent
      end
      previous = current
      current = sections.shift
    end
    nested
  end

  def self.section_level(section)
    section[:title].split(' ')[0].length
  end

  def self.update_titles(section)
    title = section[:title].rstrip
    section[:title] = title[title.index(' ') + 1..title.length]
    (section[:children] || []).each {|section| update_titles section}
  end

  def self.detach_children_from_top_level_element(sections_tree)
    (sections_tree[:children] || []).each {|section| section.delete :parent}
  end

  def self.set_permalinks_and_filenames(sections_tree)
    sections_tree[:permalink] = '/'
    sections_tree[:filename] = 'index.md'
    (sections_tree[:children] || []).map do |section|
      set_permalinks_and_filenames_helper section
    end
  end

  def self.set_permalinks_and_filenames_helper(section)
    permalink = section[:title].downcase.gsub(/\s+/, '-')
    section[:filename] = "#{permalink}.md"
    if section[:parent].nil?
      section[:permalink] = "/#{permalink}/"
    else
      section[:permalink] = "#{section[:parent][:permalink]}#{permalink}/"
    end
    (section[:children] || []).map do |section|
      set_permalinks_and_filenames_helper section
    end
  end

  def self.generate_config(section_tree)
    site_title = section_tree[:title]
    section_tree[:title] = 'Introduction'
    nav = generate_nav(section_tree).to_yaml.sub(/^---\n/m, '')
    config = <<END_OF_CONFIG
markdown: redcarpet
name: #{site_title}
exclude:
- CONTRIBUTING.md
- Gemfile
- Gemfile.lock
- LICENSE.md
- README.md
- go
- vendor

permalink: pretty
highlighter: rouge
incremental: true

sass:
  style: :compressed

# Author/Organization info to be displayed in the templates
author:
  name: 18F
  url: https://18f.gsa.gov

# Point the logo URL at a file in your repo or hosted elsewhere by your organization
logourl: /assets/img/18f-logo.png
logoalt: 18F logo

# To expand all navigation bar entries by default, set this property to true:
expand_nav: true

# Navigation
# List links that should appear in the site sidebar here
navigation:
#{nav}
repos:
- name: Guides Template
  description: Main repository
  url: https://github.com/18F/guides-template

back_link:
  url: "https://pages.18f.gov/guides/"
  text: Read more 18F Guides

google_analytics_ua: UA-48605964-19

collections:
  pages:
    output: true
    permalink: /:path/

defaults:
- scope:
    path: ""
  values:
    layout: "guides_style_18f_default"
END_OF_CONFIG
  end

  def self.generate_nav(section)
    nav = [{
      'text' => section[:title],
      'url' => 'index.html',
      'internal' => true,
    }]
    children = section[:children] || []
    nav.concat(children.map {|section| generate_nav_helper section})
  end

  def self.generate_nav_helper(section)
    children = section[:children] || []
    children = children.map {|section| generate_nav_helper section}
    item = {
      'text' => section[:title],
      'url' => "#{section[:permalink].split('/')[-1]}/",
      'internal' => true,
    }
    item['children'] = children unless children.empty?
    item
  end

  def self.generate_pages(section)
    page = ['---']
    page << "permalink: /" if section[:permalink] == '/'
    page << "title: \"#{section[:title]}\""
    page << '---'
    page << section[:content]
    children = section[:children] || []
    result = {
      filename: section[:filename],
      content: page.join("\n"),
    }
    result[:parent_dir] = section[:parent][:permalink] if section[:parent]
    [result].concat(children.flat_map {|section| generate_pages section})
  end
end

basedir = File.dirname __FILE__
pages_dir = File.join(basedir, '_pages')
config, pages = Pages18F.readme_to_pages(File.join(basedir, 'README.md'))

File.write File.join(basedir, '_config.yml'), config

css_dir = File.join basedir, 'assets', 'css'
FileUtils.mkdir_p css_dir unless Dir.exist? css_dir
File.write File.join(css_dir, 'styles.scss'), <<END_OF_CSS
---
---

@import "guides_style_18f";
END_OF_CSS

Dir.mkdir pages_dir unless Dir.exist? pages_dir

pages.each do |page|
  parent_dir = page[:parent_dir]
  parent_dir = parent_dir ? File.join(pages_dir, parent_dir) : pages_dir
  FileUtils.mkdir_p(parent_dir) unless Dir.exist?(parent_dir)
  path = File.join(parent_dir, page[:filename])
  File.write(path, page[:content])
end
