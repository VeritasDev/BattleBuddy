import React from "react"
import { connect } from 'react-redux'
import { useTranslation } from 'react-i18next'

function Items(props) {
    const { t, i18n } = useTranslation()

    return (
        <div>
            <h2>{t('headers.items')}</h2>
        </div>
    );
}

const mapStateToProps = (state /*, ownProps*/) => {
    return {
        enabledAds: state.enabledAds,
    }
}

const mapDispatchToProps = dispatch => { 
    return {}
}

export default connect(
    mapStateToProps,
    mapDispatchToProps,
)(Items)