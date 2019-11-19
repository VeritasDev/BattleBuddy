import BaseItem from './BaseItem';
import Armor from './Armor';

class InventoryGrid {
  constructor(grid) {
    this.width = grid.width;
    this.height = grid.height;
  }
}

class ChestRig extends BaseItem {
  constructor(chestRig) {
    super(chestRig);

    this.grids = chestRig.grids.map((x) => new InventoryGrid(x));
    this.totalCapacity = this.grids.reduce(
      (acc, {width, height}) => acc + width * height,
      0
    );

    this.imgBucketName = 'rigs';

    this.oneByOneSlots = 0;
    this.oneByTwoSlots = 0;
    this.oneByThreeSlots = 0;
    this.twoByTwoSlots = 0;
    this.isArmored = !!chestRig.armor && !!chestRig.armor.class;
    this.armorClass = 0;
    this.type = this.isArmored ? 'armored_chest_rig' : 'chest_rig';

    this.penalties = chestRig.penalties;

    this.speedPen = this.penalties.speed || 0;
    this.ergoPen = this.penalties.ergonomics || 0;
    this.mousePen = this.penalties.mouse || 0;
    this.hearingPen = this.penalties.deafness || 'none';

    if (this.isArmored) {
      this.armor = new Armor(chestRig);
      this.armorClass = this.armor.armorClass;
    }

    this.init();
  }

  init() {
    const {grids} = this;

    grids.forEach(({width, height}) => {
      if (width === 1 && height === 1) {
        this.oneByOneSlots = this.oneByOneSlots + 1;
      } else if (width === 1 && height === 2) {
        this.oneByTwoSlots = this.oneByTwoSlots + 1;
      } else if (width === 1 && height === 3) {
        this.oneByThreeSlots = this.oneByThreeSlots + 1;
      } else if (width === 2 && height === 2) {
        this.twoByTwoSlots = this.twoByTwoSlots + 1;
      }
    });
  }
}

export default ChestRig;
