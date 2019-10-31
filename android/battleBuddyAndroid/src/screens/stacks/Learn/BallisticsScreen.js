import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import ScrollableContainer from '../../../components/common/ScrollableContainer';
import BallisticsImage from '../../../components/learn/BallisticsImage';
import localeString from '../../../utils/localeString';
import YTVideo from '../../../components/common/YTVideo';
import {Viewport} from '@skele/components';

const Text = styled.Text`
  color: ${({theme}) => theme.colors.white};
  text-align: left;
  padding: 10px 20px;
`;

const MainTitle = styled(Text)`
  font-size: 35;
  font-weight: 300;
`;

const SubTitle = styled(Text)`
  color: ${({theme}) => theme.colors.orange};
  font-size: 20;
`;

const Bold = styled(Text)`
  font-weight: bold;
  font-size: 20;
`;

const Body = styled(Text)`
  line-height: 20;
`;

const ScrollView = styled(ScrollableContainer)`
  padding: 0 0;
`;

const BallisticsScreen = () => {
  return (
    // Check YTVideo.js for information why we use Viewport.Tracker here.
    <Viewport.Tracker>
      <ScrollView>
        <BallisticsImage
          source={require('../../../../assets/images/card_heroes/ballistics.png')}
        />
        <MainTitle>{localeString('ballistics_title')}</MainTitle>
        <SubTitle>Veritas - 13/07/2019</SubTitle>
        <Body>{localeString('ballistics_body_1')}</Body>
        <Body>{localeString('ballistics_body_2')}</Body>

        <BallisticsImage
          source={require('../../../../assets/images/card_heroes/armor.jpg')}
        />

        {/* ARMOR CLASS */}
        <Bold>{localeString('ballistics_body_2_1_title')}</Bold>
        <Body>{localeString('ballistics_body_2_1')}</Body>

        {/* DURABILITY */}
        <Bold>{localeString('ballistics_body_2_2_title')}</Bold>
        <Body>{localeString('ballistics_body_2_2_1')}</Body>
        <YTVideo videoId="3KbFMHp4NOE" />
        <Body>{localeString('ballistics_body_2_2_2')}</Body>
        <Body>{localeString('ballistics_body_2_2_3')}</Body>

        <BallisticsImage
          source={require('../../../../assets/images/card_heroes/gen4.png')}
        />

        {/* ZONES OF PROTECTION */}
        <Bold>{localeString('ballistics_body_2_3_title')}</Bold>
        <Text>{localeString('ballistics_body_2_3')}</Text>

        {/* MATERIALS */}
        <Bold>{localeString('ballistics_body_2_4_title')}</Bold>
        <Text>{localeString('ballistics_body_2_4')}</Text>

        {/* PENALTIES */}
        <Bold>{localeString('ballistics_body_2_5_title')}</Bold>
        <Text>{localeString('ballistics_body_2_5')}</Text>

        <YTVideo videoId="XDK-aLkGvkA" />

        {/* SUMMARY */}
        <Bold>{localeString('ballistics_body_3_title')}</Bold>
        <Text>{localeString('ballistics_body_3')}</Text>
      </ScrollView>
    </Viewport.Tracker>
  );
};

BallisticsScreen.navigationOptions = {
  title: 'Ballistics'
};

BallisticsScreen.propTypes = {
  navigation: PropTypes.shape({
    state: PropTypes.shape({
      params: PropTypes.shape({
        data: PropTypes.array.isRequired
      })
    })
  })
};

export default BallisticsScreen;
