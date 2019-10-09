/**
 * return value from object by dot notation
 * like 'armor.class'
 *
 * @param {object} obj
 * @param {string} desc
 */
const getDescendantProp = (obj, desc) => {
  var arr = desc.split('.');
  while (arr.length && (obj = obj[arr.shift()]));
  return obj;
};

export default getDescendantProp;
