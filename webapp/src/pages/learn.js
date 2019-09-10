import React from "react"
import { connect } from 'react-redux'
import { useTranslation } from 'react-i18next'

function Learn(props) {
    const { t, i18n } = useTranslation()

    return <h2>{t('headers.learn')}</h2>
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
)(Learn)