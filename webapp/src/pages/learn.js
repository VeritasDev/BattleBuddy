import React from "react";
import { connect } from 'react-redux';
import { useTranslation } from 'react-i18next';
import { SectionHeading } from '../styles/typography';
import { LearnPageWrapper,
    LearnPageInput
} from '../styles/pages/learn';

function Learn(props) {
    const { t, i18n } = useTranslation()

    return (
        <LearnPageWrapper>
            <SectionHeading>{t('headers.learn')}</SectionHeading>
            <LearnPageInput isHidden />
        </LearnPageWrapper>
    )
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