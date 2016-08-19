// Add your custom categories to this list
public class CategoryList {
    
    private Map<String, Schema.SObjectType> gd;
    private String objString;
    
    private List<Category> categoryList;
    
    public CategoryList(Map<String, Schema.SObjectType> gd, String objString) {
        categoryList = new List<Category>();
        this.gd = gd;
        this.objString = objString;
        addSampleCategories();
    }
    
    // Create instances of the categories, then add them to the category list 
    // Add any custom categories in this method 
    public void addSampleCategories() {
        categoryList.add(new SelectCategory(gd, objString, 'Select Queries', 'Tests the SELECT keyword'));
        categoryList.add(new OrderCategory(gd, objString, 'Order Queries', 'Tests the ability to order query results in ascending and descending order'));
        categoryList.add(new IdCategory(gd, objString, 'Id Queries', 'Checks for duplicate IDs in the external data'));
    }
    
    public List<Category> getCategoryList() {
        return categoryList;
    }
}