package models;

enum CultStatus
{
    Official;
    Recognized;
    Unrecognized;
}

class Cult
{
    public var name : String;
    public var status : CultStatus;

    public function new()
    {
    }
}