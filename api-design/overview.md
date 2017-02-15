_Under Construction.  Please read on and share feedback or propose edits._

----------------


## Background

We have set up `https://api.gsa.gov/` as an umbrella domain for GSA's APIs.  Using the [api.data.gov](https://api.data.gov/about/) service, we can organize some or all of GSA's APIs into consistent, unified endpoints without requiring them to use the same underlying system.  In other words, we can invisibly route any endpoints that the agency builds into `https://api.gsa.gov/xxxxx`.  

## Overall Proposal

Use this page (or create others in this folder) to propose and deliberate on how to use the `https://api.gsa.gov/` base URL to unify the agency APIs 

#### Benefits

* Consistent API analytics for all involved GSA APIs.  
* Cleaner URLs (e.g. `https://api.gsa.gov/systems/assist/...`  as opposed to `https://api.portal.fas.gsa.gov/assist-web/`).  
* Provides a better developer experience for the people we want using our APIs.  
* Easier to promote consistent norms from the agency API standards.  
* Makes future migrations easier since you can swap API infrastructure in and out from underneath the umbrella without changing urls.  

## Ideas for a unified endpoint struction for the agency


### Option 1 

_This is a partial view meant to outline a proposed structure.  Remember, we can customize everything after `.gov` to point to existing GSA endpoints however we want, so we can start building any of this .   _


| URL  |  Result |
|---|---|
| https://api.gsa.gov/  |  Redirects to the developer hub |
| https://api.gsa.gov/data  | Redirects to the developer hub  |
| https://api.gsa.gov/data/buildings/list  | Endpoint for property directory API |
| https://api.gsa.gov/data/travel/per-diem  | Endpoint for per-diem API  |
| https://api.gsa.gov/systems/sam  | Endpoint for the SAM API  |
| https://api.gsa.gov/systems/auctions  |  Endpoint for the Auctions API  |
| https://api.gsa.gov/systems/digital-registry  |  Endpoint for the Digital Registry API  |
| https://api.gsa.gov/documents  |  Redirects to the developer hub |
| https://api.gsa.gov/documents?tag=press_release+pbs  | Returns documents with the `press-release` and `pbs` tags  |
| https://api.gsa.gov/documents?id=32330  | Returns a specific document  |


##### Proposed next steps 

1. Merge the PR that creates this page.  
2. Circulate it and more context to the agency API working group.  
3. Gain consensus on the idea.  
4. Have a team (perhaps team CTO) agree to chair the effort.  
5. Update the above with the candidates for the first round of existing APIs that would be incorporated.  
6. Give these existing APIs `api.gsa.gov` URLs.  
7. Create and maintain a master directory of `api.gsa.gov` endpoints (it'd look like the above chart except be what exists in real life).  
8. Update the API documentation for the first rounds APIs to use the `api.gsa.gov` URLs.  
9. Create and maintain a sandbox section to the master directory of `api.gsa.gov` endpoints where anyone can propose further additions or refinements.  

