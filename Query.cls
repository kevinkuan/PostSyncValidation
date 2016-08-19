// Query that will be executed to verify external objects
public class Query {
    private String query; // the query string itself, can be ran in workbench
    private String description; // details on what the query is testing 
    private Boolean passed; // flag for whether the query yielded correct results
    private String errorType; // the type of error that was generated, blank if it passed
    private String errorMessage; // an explanation of what caused the error, blank if it pased
    
    // Each query must be instantiated with the query string that will be executed and a description of what the query tests
    // passed, errorType, and errorMessage are set when validate is called
    public Query (String query, String description) {
        this.query = query;
        this.description = description;
    }
    
    public String getQuery() {
        return query;
    }
    
    public String getDescription() {
        return description;
    }
    
    public Boolean getPassed() {
        return passed;
    }
    
    public void setPassed(Boolean passed) {
        this.passed = passed;
    }
    
    public String getErrorType() {
        return errorType;
    }
    
    public void setErrorType(String errorType) {
        this.errorType = errorType;
    }
    
    public String getErrorMessage() {
        return errorMessage;
    }
    
    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
    
    
}