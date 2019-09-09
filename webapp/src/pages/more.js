import React from "react"
import { connect } from 'react-redux'
import { useTranslation } from 'react-i18next'
import { FormControlLabel, Switch } from '@material-ui/core'

import { setEnableAds, updateEnableAds } from '../actions'

function More(props) {
    const { t, i18n } = useTranslation()

    const handleEnabledAdsChange = (checked) => {
        console.log('checked:' + checked)
        // dispatches actions to enable ads, the uncommented function below should be used when firebase is implemented in actions.js
        props.setEnableAds(checked)
        //props.updateEnableAds(checked)
    }

    return (
        <div>
            <h2>{t('headers.more')}</h2>
            <FormControlLabel
                control={
                    <Switch
                        checked={props.enabledAds}
                        onChange={(event, checked) => handleEnabledAdsChange(checked)}
                        value="enabledAds"
                        inputProps={{ 'aria-label': 'secondary checkbox' }}
                    />
                }
                label={t('labels.more.enableAds')}
            />
        </div>
    )
}

const mapStateToProps = (state /*, ownProps*/) => {
    return {
        enabledAds: state.enabledAds,
    }
}

const mapDispatchToProps = dispatch => { 
    return {
        setEnableAds: (enabledAds) => {
            dispatch(setEnableAds(enabledAds))
        },
        updateEnableAds: (enabled) => {
            dispatch(updateEnableAds(enabled))
        },
    }
}

export default connect(
    mapStateToProps,
    mapDispatchToProps,
)(More)