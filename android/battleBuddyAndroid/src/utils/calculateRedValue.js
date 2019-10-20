/**
 * Util to return right Red value in "rgb".
 * This is used in the compare screen to give each bar a different color
 * ranging from 255 to 0
 *
 * @param {number} index - current index of array
 * @param {number} totalAmount - total of items in array
 */

const calculateRedValue = (index, totalAmount) => {
  const min = 0;
  const max = totalAmount - 1;
  const minAllowed = 0;
  const maxAllowed = 255;

  if (min - max === 0) return maxAllowed;

  // TODO: Review formula.
  /* prettier-ignore */
  const result = maxAllowed - ((maxAllowed - min) * (index - min)) / (max - min) + minAllowed;

  return Math.round(result);
};

export default calculateRedValue;
