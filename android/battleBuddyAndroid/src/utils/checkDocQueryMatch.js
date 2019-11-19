import getDescendantProp from './getDescendantProp';

const compareValues = {
  firearm: ['description', 'name', 'shortName', 'class', 'caliber'],
  armor: ['description', 'name', 'shortName', 'armor.material.name', 'type'],
  tacticalrig: ['description', 'name', 'shortName'],
  ammo: ['name', 'shortName', 'caliber'],
  medical: ['name', 'shortName'],
  grenade: ['name'],
  melee: ['name']
};

const checkDocQueryMatch = (item, collection, query) => {
  const properties = compareValues[collection];
  let docMatchesQuery = false;

  properties.forEach((prop) => {
    if (!docMatchesQuery) {
      docMatchesQuery = getDescendantProp(item, prop)
        .toLowerCase()
        .includes(query.toLowerCase());
    }
  });

  return docMatchesQuery;
};

export default checkDocQueryMatch;
