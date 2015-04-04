package models;

enum EthnyStatus
{
    Dominant;
    Installed;
    Prejudiced;
}

class Ethny
{
    public var name : String;
    public var status : EthnyStatus;

    public function new()
    {
    }
}