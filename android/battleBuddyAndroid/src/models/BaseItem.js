export default class BaseItem {
  constructor(item) {
    this.type = item.type;
    this.id = item._id;
    this.kind = item._kind;
    this.displayNameShort = item.shortName;
    this.displayName = item.name;
    this.displayDescription = item.description;
    this.ergonomics = item.ergonomics || 0;
  }
}
