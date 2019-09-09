/*
 * import action types
 */
import { SET_ENABLED_ADS, FIREBASE_UPADTE_ADS_FAILED, FIREBASE_UPDATE_ADS_REQUESTING } from './actionTypes'

/*
 * action creators
 */

function setFirebaseRequestingUpdateAds(){
  return {
    type: FIREBASE_UPDATE_ADS_REQUESTING
  }
}

function setFirebaseFailedUpdateAds(){
  return {
    type: FIREBASE_UPADTE_ADS_FAILED
  }
}

export function setEnableAds(enabledAds) {
  return { 
    type: SET_ENABLED_ADS,
    enabledAds
  }
}

function requestFirebaseUpdate(firebaseUserId, newAdsEnabledState){
  //json.enabledStatus is just a placehodler for the firebase response if it was enabled or disabled correctly
  return dispatch => {
    //set the state to know that a request is being sent at the moment (for loading spinner etc.)
    dispatch(setFirebaseRequestingUpdateAds())
    //TODO: add firebase SDK or fetch to firebase API here to update the ads enabled status of the user, 
    // then dispatch the value of the response to enable or disable ads if the request was successful

    //example
    //return fetch(`https://firebase`)
    //  .then(response => response.json())
    //  .then(json => dispatch(setEnableAds(json.enabledStatus)))

    //when failed then call dispatch(setFirebaseFailedUpdateAds())
  }
}

export function updateEnableAds(enabled) {
  // firebaseUserId needs to be saved to state on first login and actions for that need to be still created
  // Note that the function also receives getState() which lets you choose what to dispatch next.
  // This is useful for avoiding a network request if a cached value is already available.

  return (dispatch, getState) => {
    const firebaseUserId = getState().firebaseUserId
    if (firebaseUserId) {
      // Dispatch a thunk from thunk!
      return dispatch(requestFirebaseUpdate(firebaseUserId, enabled))
    } else {
      // Let the calling code know there's nothing to wait for.
      return Promise.resolve()
    }
  }
}