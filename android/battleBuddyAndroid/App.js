import React from 'react';
import styled from 'styled-components/native';
import {StatusBar} from 'react-native';
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

  if (authenticated) {
    return (
      <AuthenticatedAppProviders>
        <Theme>
          <StatusBar
            barStyle="light-content"
            backgroundColor={theme.colors.black}
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
