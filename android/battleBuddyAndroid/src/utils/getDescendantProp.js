export class ParamError extends TypeError {
  constructor(type, received) {
    super();
    this.message = `argument passed must be of type ${type} but received: ${typeof received}`;
  }
}

/**
 * return value from object by dot notation
 * like 'armor.class'
 *
 * @param {object} obj
 * @param {string} desc
 */
const getDescendantProp = (obj, desc) => {
  if (typeof obj !== 'object') {
    throw new ParamError('object', obj);
  }
  if (typeof desc !== 'string') {
    throw new ParamError('string', desc);
  }
  return desc.split('.').reduce((a, b) => a[b], obj);
};

export default getDescendantProp;
