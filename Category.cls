// An abstract class for any kind of category the user will create
public abstract class Category {
    private List<Query> queries; // the list of queries associated with the category
    private String name; // the title of the category
    private String description; // details on what the category is testing
    private boolean selected; // true if the category is selected for querying
    
    // Each category must have its name title and a description of what it tests
    public Category (String name, String description) {
        this.name = name;
        this.description = description;
    }
    
    // returns the description of what the category is testing
    public String getDescription() {
        return this.description;
    } 
    
    // returns the list of queries that will be called 
    public List<Query> getQueries() {
        return this.queries;
    }
    
    public void setQueries(List<Query> queries) {
        this.queries = queries;
    }
    
    // returns the title of the category 
    public String getName() {
        return this.name;
    }
    
    // returns whether the category will run its queries
    public Boolean getSelected() {
        return this.selected;
    }
    
    public void setSelected(Boolean selected) {
        this.selected = selected;
    }
    
    // Each custom category will have their own validation on their queries
    public virtual void validate(){
        for (Query query: this.queries) {
            try {
                List<sObject> sobjList = Database.query(query.getQuery()); 
                if (sobjList.size() == 0) {
                    query.setErrorType('No records found');
                    query.setErrorMessage('The query ran but didn\'t yield any records.');
                    query.setPassed(false);
                } else {
                    query.setPassed(true);
                }
            }
            catch (Exception e) {
                query.setErrorType(e.getTypeName());
                query.setErrorMessage(e.getMessage());
                query.setPassed(false);
            } 
        }
    }
    
}