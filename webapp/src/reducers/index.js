import { SET_ENABLED_ADS, FIREBASE_UPDATE_ADS_REQUESTING, FIREBASE_UPADTE_ADS_RECEIVING, FIREBASE_UPADTE_ADS_FAILED } from "../actions/actionTypes"

const initialState = {
    enabledAds: true,
    firebaseUserId: null,
    isRequestingUpdateAds: false,
}
  
function rootReducer(state = initialState, action) {
    switch(action.type){
        case FIREBASE_UPADTE_ADS_FAILED:
            return {
                ...state,
                isRequestingUpdateAds: false,
            }
        case FIREBASE_UPDATE_ADS_REQUESTING:
            return {
                ...state,
                isRequestingUpdateAds: true,
            }
        case FIREBASE_UPADTE_ADS_RECEIVING:
            return {
                ...state,
                enabledAds: action.enabledAds,
                isRequestingUpdateAds: false,
            }
        case SET_ENABLED_ADS:
            return {
                ...state,
                enabledAds: action.enabledAds,
            }
        default: return state
    }
}

export default rootReducer