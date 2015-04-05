package models;

import models.Resource;

enum CultStatus
{
    Official;
    Recognized;
    Unrecognized;
}

@:allow(BuilderState)
class Cult extends Faction
{
    public var status(default, null) : CultStatus;
    public var need(default, null) : Resource;

    public function new(name : String, status : CultStatus, resource : Resource, need : Resource)
    {
        super(name, resource);
        this.status = status;
    }
}