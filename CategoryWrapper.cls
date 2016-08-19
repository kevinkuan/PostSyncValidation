// Wrapper class to display category information for Visualforce
// Selected keesp track of whether the category is chosen to be queried
public class CategoryWrapper{
    private Category category{get;set;}
    private boolean selected {get;set;}
    
    public CategoryWrapper(Category category){
        this.category = category;
        this.selected = false;
    }
}