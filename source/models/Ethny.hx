package models;

enum EthnyStatus
{
  Dominant;
  Installed;
  Prejudiced;
}

@:allow(BuilderState)
  class Ethny
{
  public var name(default, null) : String;
  public var status(default, null) : EthnyStatus;

  public function new(name : String)
  {
    this.name = name;
    status = EthnyStatus.Installed;
  }
}
