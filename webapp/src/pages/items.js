import React from "react";
import { connect } from 'react-redux';
import { useTranslation } from 'react-i18next';
import { SectionHeading } from "../styles/typography";

function Items(props) {
    const { t, i18n } = useTranslation()

    return <SectionHeading>{t('headers.items')}</SectionHeading>;
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