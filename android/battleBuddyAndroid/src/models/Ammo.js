import BaseItem from './BaseItem';

export default class Ammo extends BaseItem {
  constructor(ammo) {
    super(ammo);

    this.caliber = ammo.caliber;
    this.damage = ammo.damage;
    this.armorDamage = ammo.armorDamage;
    this.penetration = ammo.penetration;
    this.fragmentation = ammo.fragmentation;
    this.fragmentationChance = ammo.fragmentation.chance;
    this.muzzleVelocity = ammo.velocity;
    this.subsonic = ammo.subsonic;
    this.tracer = ammo.tracer;
    this.projectileCount = ammo.pellets || 1;
    this.totalDamage = this.damage * this.projectileCount;
    this.totalArmorDamage = this.armorDamage * this.projectileCount;
  }
}
