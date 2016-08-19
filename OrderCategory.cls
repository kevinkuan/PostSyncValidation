// Category with queries that tests the ability to order query results in ascending and descending order
public virtual class OrderCategory extends Category {
    
    private Map<String, Schema.SObjectType> gd;
    private String objString;
    private String orderFieldName;
    
    public OrderCategory(Map<String, Schema.SObjectType> gd, String objString, String name, String description) {
        super(name, description);
        this.gd = gd;
        this.objString = objString;
    }
    
    // Creating the queries to test order
    public List<Query> makeOrderQueries() { 
        Schema.SObjectType obj = gd.get(objString);
        Schema.DescribeSObjectResult result = obj.getDescribe();
        Map<String,Schema.SObjectField> fieldsMap = result.fields.getMap();
        List<Schema.SObjectField> fieldList = fieldsMap.values();
        
        List<Query> orderQueries = new List<Query>();
        for (Schema.SObjectField field: fieldList) {
            Schema.DisplayType fieldType = field.getDescribe().getType();
            if (String.valueOf(fieldType) == 'String') {
                this.orderFieldName = field.getDescribe().getName();
                try {
                    
                    String ascQueryString = 'SELECT ' + orderFieldName + ' FROM ' + objString + ' ORDER BY ' + orderFieldName + ' ASC NULLS LAST LIMIT 5';
                    String descQueryString = 'SELECT ' + orderFieldName + ' FROM ' + objString + ' ORDER BY ' + orderFieldName + ' DESC NULLS LAST LIMIT 5';
                    
                    Query ascQuery = new Query(ascQueryString, 'Ascending order');
                    Query descQuery = new Query(descQueryString, 'Descending order');
                    
                    orderQueries.add(ascQuery);
                    orderQueries.add(descQuery);
                    
                    break;
                } catch (Exception e) {
                    continue;
                }
            }
        }       
        
        return orderQueries;
    }
    
    public override void validate() {
        setQueries(makeOrderQueries());
        for (Query query: this.getQueries()) {
            String testQuery = query.getQuery();
            try {
                List<sObject> sobjList = Database.query(query.getQuery()); 
                if (sobjList.size() != 0) {
                    if (testQuery.contains('ASC') && !checkASCQueries(sobjList)) {
                        query.setErrorType('Incorrect results');
                        query.setErrorMessage('The expected sorted list didn\'t match the actual sorted list.');
                        query.setPassed(false);
                    } else if (testQuery.contains('DESC') && !checkDESCQueries(sobjList)) {
                        query.setErrorType('Incorrect results');
                        query.setErrorMessage('The expected sorted list didn\'t match the actual sorted list.');
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
    
    // Checking if the returned objects are in ASC order
    public boolean checkASCQueries(List<sObject> stringValueASC) {
        List<String> orderQueries = new List<String>();
        Schema.SObjectType obj = gd.get(objString);
        Schema.DescribeSObjectResult result = obj.getDescribe();
        Map<String,Schema.SObjectField> fieldsMap = result.fields.getMap();
        List<String> testingOrderQueries = new List<String>();
        List<String> testingOrderQueriesSorted = new List<String>();
        Integer testingOrderQueriesSize = 5;
        if (stringValueASC.size() < 5) {
            testingOrderQueriesSize = stringValueASC.size();
        }  
        for (Integer i = 0; i < testingOrderQueriesSize; i++)
        {
            String ascString = (String)(stringValueASC.get(i).get(orderFieldName));
            testingOrderQueries.add(ascString);
            testingOrderQueriesSorted.add(ascString);
        } 
        testingOrderQueriesSorted.sort();
        
        for (Integer i = 0; i < testingOrderQueriesSize; i++) {
            if (testingOrderQueries.get(i) != testingOrderQueriesSorted.get(i))
            {
                return false;
            }
        } 
        
        return true;
    }
    
    // Checking if the returned objects are in DESC order
    public boolean checkDESCQueries(List<sObject> stringValueDESC) {
        List<String> orderQueries = new List<String>();
        Schema.SObjectType obj = gd.get(objString);
        Schema.DescribeSObjectResult result = obj.getDescribe();
        Map<String,Schema.SObjectField> fieldsMap = result.fields.getMap();
        List<String> testingOrderQueries = new List<String>();
        List<String> testingOrderQueriesSorted = new List<String>();
        Integer testingOrderQueriesSize = 5;
        if (stringValueDESC.size() < 5) {
            testingOrderQueriesSize = stringValueDESC.size();
        }  
        for (Integer i = 0; i < testingOrderQueriesSize; i++)
        {
            String descString = (String)(stringValueDESC.get(i).get(orderFieldName));
            testingOrderQueries.add(descString);
            testingOrderQueriesSorted.add(descString);
        } 
        testingOrderQueriesSorted.sort();
        
        for (Integer i = 0; i < testingOrderQueriesSize; i++) {
            if (testingOrderQueries.get(testingOrderQueriesSize-i-1) != testingOrderQueriesSorted.get(i))
            {
                return false;
            }
        } 
        return true;
    }
    
    
}