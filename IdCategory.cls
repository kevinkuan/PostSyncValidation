// Category with queries that check for duplicate Ids in the external data
public virtual class IdCategory extends Category {
    
    private Map<String, Schema.SObjectType> gd;
    private String objString;
    
    public IdCategory(Map<String, Schema.SObjectType> gd, String objString, String name, String description) {
        super(name, description);
        this.gd = gd;
        this.objString = objString;
    }
    
    // Creates a query that checks for duplicate IDs
    // Example: SELECT ExternalId FROM googleDrive__x WHERE ExternalId ='0B4z2gzEmkDDCLURPQU0zRzNOOEE' LIMIT 2
    public List<Query> makeIdQueries() {
        // Testing duplicate IDs
        List<Query> queries = new List<Query>();
        String idListQuery = 'SELECT ExternalId FROM ' + objString;   
        List<sObject> idQueryList = Database.query(idListQuery);
        
        Map<String, Boolean> duplicateIDMap = new Map<String, Boolean>();
        
        for (sObject obj: idQueryList) {
            String objId = (String) (obj.get('ExternalId'));
            if (duplicateIDMap.get(objID) == null) {
                duplicateIDMap.put(objID, true);
            } else {
                String duplicateIdQuery = 'SELECT ExternalId FROM ' + objString + ' WHERE ExternalId =\'' + objId + '\' LIMIT 2';
                queries.add(new Query(duplicateIdQuery, 'Duplicate ID'));
                break;
            }
        }
        if (queries.size() == 0) {
            String duplicateIdQuery = 'SELECT ExternalId FROM ' + objString + ' WHERE ExternalId =\'' + (String)(idQueryList.get(0).get('ExternalId')) + '\' LIMIT 2';
            queries.add(new Query(duplicateIdQuery, 'Duplicate ID'));
        }
        
        return queries;
    }
    
    public override void validate() {
        setQueries(makeIdQueries());
        for (Query query: this.getQueries()) {
            try {
                List<sObject> sobjList = Database.query(query.getQuery()); 
                if (sobjList.size() != 0) {
                    if (sobjList.size() == 2) {
                        query.setErrorType('External Object Error');
                        query.setErrorMessage('A duplicate ID exists.');
                        query.setPassed(false);
                    } else {
                        query.setPassed(true);
                    }
                } else {
                    query.setErrorType('No records found');
                    query.setErrorMessage('The query ran but didn\'t return any records.');
                    query.setPassed(false);	
                }
            } catch (Exception e) {
                query.setErrorType(e.getTypeName());
                query.setErrorMessage(e.getMessage());
                query.setPassed(false);
            } 
            
        }
    }
}