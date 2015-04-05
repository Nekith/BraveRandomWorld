package models;

import models.Resource;

class SocialFaction extends Faction
{
    public function new(name : String, resource : Resource)
    {
        super(name, resource);
    }
}