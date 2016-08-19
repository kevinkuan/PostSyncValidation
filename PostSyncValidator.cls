// This is the main class for validation and for connecting to the visualforce pages. To customize, add categories to the CategoryList
public class PostSyncValidator {
    
    private Map<String, Schema.SObjectType> gd;
    private List<Category> queryCategories;
    private List<Schema.SObjectType> objectList;
    private List<Schema.SObjectField> fieldList;
    private List<String> sortingObjectList;
    private String orderFieldName;
    private List<String> finalQueryList;
    private Map<String, SelectOption> labelSelectOptionMap;
    private Map<String,List<String>> selectOptionToQueryMap;
    private Map<String, String>  objectLabelNameMap;
    
    public String objString {get;set;}
    public List<SelectOption> selectedObject {get;set;} 
    public List<QueryWrapper> queriesPassed {get;set;} 
    public List<QueryWrapper> queriesFailed {get;set;}
    public List<Category> categoryList {get;set;}
    public Boolean selectAllCategories{get;set;}
    public Boolean showPassTable {get;set;}
    public Boolean showFailTable {get;set;}
    public String objName {get;set;}
    
    public PostSyncValidator(){
        initializeValues();
    }
    
    public void initializeValues() {
        objString = '';
        labelSelectOptionMap = new Map<String,SelectOption>();
        selectOptionToQueryMap = new Map<String,List<String>>();
        objectLabelNameMap = new Map<String, String>();
        sortingObjectList = new String[]{};
            queryCategories = new Category[]{};
                finalQueryList = new String[]{};
                    
                    this.selectedObject = new SelectOption[]{};
                        this.queriesPassed = new QueryWrapper[]{};
                            this.queriesFailed = new QueryWrapper[]{}; 
                                this.categoryList = new Category[]{};
                                    this.selectAllCategories = false;
        this.showFailTable = false;
        this.showPassTable = false;     
        this.objName = '';
        
        gd = Schema.getGlobalDescribe();
        objectList = gd.values();
        
        // Filterting out external objects from the object list 
        for(Schema.SObjectType type: objectList) {
            System.debug('Type: ' + type);
            Schema.DescribeSObjectResult result = type.getDescribe();
            if (result.getName().contains('__x')) {
                SelectOption selection = new SelectOption(result.getName(), result.getLabel());
                sortingObjectList.add(result.getLabel());
                labelSelectOptionMap.put(result.getLabel(), selection);
                objectLabelNameMap.put(result.getName(), result.getLabel());
            }
        }
        
        // Sorting and adding the external objects to the drop down list
        sortingObjectList.sort();
        for (String sortedString: sortingObjectList) {
            SelectOption sortedSelection = labelSelectOptionMap.get(sortedString);
            this.selectedObject.add(sortedSelection);
        }   
    } 
    
    // Create the first page that selects the external object
    public PageReference firstPage() {
        initializeValues();
        PageReference pageRef = new PageReference('/apex/PostSyncFirstPage');
        pageRef.setRedirect(false);  
        return pageRef;
    }
    
    // Create the results page after object selection
    public PageReference secondPage() {
        PageReference pageRef = new PageReference('/apex/PostSyncSecondPage');
        pageRef.setRedirect(false);         
        initializeQueries();
        this.objName = objectLabelNameMap.get(objString);
        return pageRef;
    }  
    
    // Initialize all of the queries that can potentially be called
    public void initializeQueries() {        
        CategoryList categoryList = new CategoryList(gd, objString);
        
        for (Category category: categoryList.getCategoryList()) {
            this.categoryList.add(category);
        }
    }  
    
    // Called after selecting the query category and running them
    public PageReference runQueries() {
        queryCategories = new List<Category>();
        this.queriesPassed = new QueryWrapper[]{};
            this.queriesFailed = new QueryWrapper[]{};
                
                // Figuring out which query categories to run
                for (Category category: this.categoryList) {
                    if (category.getSelected() == true) {
                        queryCategories.add(category);
                    }
                }    
        
        // Fetching the queries for each category and running them
        for (Category queryCategory: queryCategories) {
            queryCategory.validate();
            List<Query> queryList = queryCategory.getQueries();
            for (Query query: queryList) {
                if (query.getPassed() == true) {
                    this.queriesPassed.add(new QueryWrapper(query, queryCategory.getName()));
                } else {
                    this.queriesFailed.add(new QueryWrapper(query, queryCategory.getName()));
                }
            }
        }
        renderTable();
        return null;
    }
    
    // Checks whether to render the table for passed/failed queries
    public void renderTable() {
        if (this.queriesFailed.size() != 0) {
            this.showFailTable = true;
        } else {
            this.showFailTable = false;
        }
        if (queriesPassed.size() != 0) {
            this.showPassTable = true;
        }  else {
            this.showPassTable = false;
        }
    }
    
    // Selects all of the query categories
    public PageReference selectAll () {
        for (Category category: this.categoryList) {
            if (selectAllCategories == true) {
                category.setSelected(true);
            } else {
                category.setSelected(false);
            }
        }
        return null;
    }
    
}