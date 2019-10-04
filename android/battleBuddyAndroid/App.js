import React, {useEffect} from 'react';
import styled from 'styled-components/native';
import {StatusBar} from 'react-native';
import SplashScreen from 'react-native-splash-screen';
import {createAppContainer} from 'react-navigation';
import tabNavigator from './src/navigation/MainTabNavigator';
import Theme, {theme} from './src/components/Theme';

const Navigator = createAppContainer(tabNavigator);
const Container = styled.View`
  flex: 1;
`;

const App = () => {
  useEffect(() => {
    SplashScreen.hide();
  }, []);

  return (
    <Theme>
      <StatusBar
        barStyle="light-content"
        backgroundColor={theme.colors.almostBlack}
      />
      <Container>
        <Navigator />
      </Container>
    </Theme>
  );
};

export default App;
