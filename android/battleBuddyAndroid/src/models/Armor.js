import BaseItem from './BaseItem';

export default class Armor extends BaseItem {
  constructor(armor) {
    super(armor);
    this.armorProperties = armor.armor;
    this.material = this.armorProperties.material;
    this.materialName = this.material.name;
    this.destructibility = this.material.destructibility;
    this.durability = this.armorProperties.durability;
    this.armorClass = this.armorProperties.class;
    this.rawZones = this.armorProperties.zones;
    this.zones = this.rawZones.join(', ');
    this.bluntTp = this.armorProperties.bluntTroughput;
    this.penalties = armor.penalties;

    this.armorType = armor.type;
    this.protectsTopHead = this.rawZones.includes('top');
    this.protectsEyes = this.rawZones.includes('eyes');
    this.protectsJaws = this.rawZones.includes('jaws');
    this.protectsEars = this.rawZones.includes('ears');
    this.protectsNape = this.rawZones.includes('nape');
    this.protectsChest = this.rawZones.includes('chest');
    this.protectsStomach = this.rawZones.includes('stomach');
    this.protectsLeftArm = this.rawZones.includes('leftarm');
    this.protectsRightArm = this.rawZones.includes('rightarm');
    this.protectsLeftLeg = this.rawZones.includes('leftleg');
    this.protectsRightLeg = this.rawZones.includes('rightleg');

    this.speedPen = this.penalties.speed || 0;
    this.ergoPen = this.penalties.ergonomics || 0;
    this.mousePen = this.penalties.mouse || 0;
    this.hearingPen = this.penalties.deafness || 'none';
  }
}
