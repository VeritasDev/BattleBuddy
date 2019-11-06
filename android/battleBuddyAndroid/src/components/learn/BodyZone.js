import React, {useState, useEffect} from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import {ImageBackground} from 'react-native';

const hpColors = ['#0B6319', '#5A680A', '#666101', '#664500', '#FF0100'];

const Text = styled.Text`
  color: white;
  text-transform: uppercase;
  font-size: 10px;
  font-weight: bold;
  padding: 3px 3px 3px 5px;
`;

const Container = styled.TouchableOpacity`
  width: 100px;
`;

const HPBarContainer = styled.View`
  border: 1px solid ${({blacked}) => (blacked ? 'red' : 'white')};
  text-align: center;
  position: relative;
`;

const HPText = styled.Text`
  color: ${({blacked}) => (blacked ? 'red' : 'white')};
  text-align: center;
  font-size: 10px;
`;

const Bar = styled.View`
  position: absolute;
  left: 0px;
  top: 0px;
  bottom: 0px;
  background: ${({color}) => color};
`;

const BodyZone = ({name, hp, maxHp, ...props}) => {
  const [state, setState] = useState(hp);
  const hpPercentage = (state / maxHp) * 100;
  const blacked = hpPercentage === 0;
  let color;

  useEffect(() => {
    setState(hp);
  }, [hp]);

  if (hpPercentage >= 60) {
    color = hpColors[0];
  } else if (hpPercentage >= 40) {
    color = hpColors[1];
  } else if (hpPercentage >= 30) {
    color = hpColors[2];
  } else if (hpPercentage >= 10) {
    color = hpColors[3];
  } else if (hpPercentage < 10) {
    color = hpColors[4];
  } else if (blacked) {
    color = 'black';
  }

  return (
    <Container
      {...props}
      onPress={() => setState((prevState) => prevState - 10)}
    >
      <ImageBackground
        resizeMode="contain"
        style={{width: 'auto', flexGrow: 0}}
        source={require('../../../assets/images/damage_calculator/body_zone_background.imageset/zone_background.png')}
      >
        <Text>{name}</Text>
      </ImageBackground>
      <HPBarContainer blacked={blacked} hp={hp} maxHp={maxHp}>
        <Bar color={color} width={`${hpPercentage}%`} />
        <HPText blacked={blacked}>
          {state}/{maxHp}
        </HPText>
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
