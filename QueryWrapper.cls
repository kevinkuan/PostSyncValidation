// Wrapper class to display query information for Visualforce
// Keeps track of the category name in addition to the query details
public class QueryWrapper{
    
    private Query query;
    private String categoryName;
    
    public QueryWrapper(Query query, String categoryName) {
        this.query = query;
        this.categoryName = categoryName;
    }
    
    public Query getQuery() {
        return query;
    }
    
    public void setQuery(Query query) {
        this.query = query;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
}