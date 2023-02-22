import ballerina/graphql;
import ballerinax/mysql.driver as _;
import ballerinax/mysql;

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;
configurable string DATABASE = ?;

final mysql:Client dbClient = check new(
    host=HOST, user=USER, password=PASSWORD, port=PORT, database="shiro_db", connectionPool={maxOpenConnections: 3}
);

# catalog item
public type Item record {|
    int code?;
    string title;
    string includes;
    string intended_for;
    string color;
    string material;    
    float price;
    int quantity;
|};

# order 
public type Order record {|
    int id?;
    int item_code;
    float price;
    int amount;
    int total;
    string customer;
    string card;
|};


public type CovidEntry record {|
    readonly string isoCode;
    string country;
    decimal cases?;
    decimal deaths?;
    decimal recovered?;
    decimal active?;
|};

table<CovidEntry> key(isoCode) covidEntriesTable = table [
    {isoCode: "AFG", country: "Afghanistan", cases: 159303, deaths: 7386, recovered: 146084, active: 5833},
    {isoCode: "SL", country: "Sri Lanka", cases: 598536, deaths: 15243, recovered: 568637, active: 14656},
    {isoCode: "US", country: "USA", cases: 69808350, deaths: 880976, recovered: 43892277, active: 25035097}
];


public distinct service class ItemData {
    private final readonly & Item entryRecord;

    function init(Item entryRecord) {
        self.entryRecord = entryRecord.cloneReadOnly();
    }

    resource function get title() returns string {
        return self.entryRecord.title;
    }

    resource function get includes() returns string {
        return self.entryRecord.includes;
    }

    resource function get intended_for() returns string {
        return self.entryRecord.intended_for;
    }

    resource function get color() returns string {
        return self.entryRecord.color;
    }

    resource function get material() returns string {
        return self.entryRecord.material;
    }

    resource function get price() returns float {
        return self.entryRecord.price;
    }

    resource function get quantity() returns int {
        
        return self.entryRecord.quantity;
    }

}


public distinct service class CovidData {
    private final readonly & CovidEntry entryRecord;

    function init(CovidEntry entryRecord) {
        self.entryRecord = entryRecord.cloneReadOnly();
    }

    resource function get isoCode() returns string {
        return self.entryRecord.isoCode;
    }

    resource function get country() returns string {
        return self.entryRecord.country;
    }

    resource function get cases() returns decimal? {
        if self.entryRecord.cases is decimal {
            return self.entryRecord.cases / 1000;
        }
        return;
    }

    resource function get deaths() returns decimal? {
        if self.entryRecord.deaths is decimal {
            return self.entryRecord.deaths / 1000;
        }
        return;
    }

    resource function get recovered() returns decimal? {
        if self.entryRecord.recovered is decimal {
            return self.entryRecord.recovered / 1000;
        }
        return;
    }

    resource function get active() returns decimal? {
        if self.entryRecord.active is decimal {
            return self.entryRecord.active / 1000;
        }
        return;
    }
}

service /covid19 on new graphql:Listener(9000) {
    resource function get all() returns ItemData[] {
        Item[] items;
        Item[]|error? unionResult = getAllItems();
        if unionResult is Item[] {
            items = unionResult;
        } else {
            items = [];
        }
        return items.map(entry => new ItemData(entry));
        //CovidEntry[] covidEntries = covidEntriesTable.toArray().cloneReadOnly();
        //return covidEntries.map(entry => new CovidData(entry));
    }

    resource function get filter(int code) returns ItemData? {
        Item[] items;
        Item[]|error? unionResult = getAllItems();
        if unionResult is Item[] {
            items = unionResult;
        } else {
            items = [];
        }

        //CovidEntry? covidEntry = covidEntriesTable[isoCode];
        //Item? item;
        Item? item_to_send;

        foreach Item item in items {
            if (item.code == code)
            {
                item_to_send = item;
                return new ItemData(item);
            }
        }
        return;
    }

    remote function add(Item entry) returns ItemData {
        //covidEntriesTable.add(entry);
        return new ItemData(entry);
    }
}

