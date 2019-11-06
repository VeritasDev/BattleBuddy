import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import {ImageBackground} from 'react-native';

const Text = styled.Text`
  color: white;
  text-transform: uppercase;
  font-size: 10px;
  font-weight: bold;
  padding: 3px 3px 3px 5px;
`;

const Container = styled.View`
  width: 100px;
`;

const HPBarContainer = styled.View`
  border: 1px solid rgba(255, 255, 255, 0.5);
  text-align: center;
  padding: 1px;
`;

const HPText = styled.Text`
  color: white;
  text-align: center;
  font-size: 10px;
`;

const Bar = styled.View`
  width: 100%;
  background: ${({theme}) => theme.colors.green};
`;

const BodyZone = ({name, hp, maxHp, ...props}) => {
  return (
    <Container {...props}>
      <ImageBackground
        resizeMode="contain"
        style={{width: 'auto', flexGrow: 0}}
        source={require('../../../assets/images/damage_calculator/body_zone_background.imageset/zone_background.png')}
      >
        <Text>{name}</Text>
      </ImageBackground>
      <HPBarContainer hp={hp} maxHp={maxHp}>
        <Bar>
          <HPText>
            {hp}/{maxHp}
          </HPText>
        </Bar>
      </HPBarContainer>
    </Container>
  );
};

BodyZone.propTypes = {
  name: PropTypes.string.isRequired,
  hp: PropTypes.number.isRequired,
  maxHp: PropTypes.number.isRequired
};

export default BodyZone;
