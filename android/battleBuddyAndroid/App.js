import React, {useEffect} from 'react';
import styled from 'styled-components/native';
import {StatusBar} from 'react-native';
import SplashScreen from 'react-native-splash-screen';
import {createAppContainer} from 'react-navigation';
import tabNavigator from './src/navigation/MainTabNavigator';
import Theme, {theme} from './src/components/Theme';
import {useAuthentication} from './src/context/AuthenticationProvider';
import AuthenticatedAppProviders from './src/components/AuthenticatedAppProviders';

const Navigator = createAppContainer(tabNavigator);
const Container = styled.View`
  flex: 1;
`;

const App = () => {
  const {authenticated} = useAuthentication();

  useEffect(() => {
    if (authenticated) {
      SplashScreen.hide();
    }
  }, [authenticated]);

  if (authenticated) {
    return (
      <AuthenticatedAppProviders>
        <Theme>
          <StatusBar
            barStyle="light-content"
            backgroundColor={theme.colors.almostBlack}
          />
          <Container>
            <Navigator />
          </Container>
        </Theme>
      </AuthenticatedAppProviders>
    );
  } else {
    return null;
  }
};

export default App;
