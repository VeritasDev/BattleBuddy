import React, {useState} from 'react';
import styled from 'styled-components/native';
import {AppLoading} from 'expo';
import {Asset} from 'expo-asset';
import * as Font from 'expo-font';
import {Ionicons} from '@expo/vector-icons';

import AppNavigator from './navigation/AppNavigator';
import Theme from './components/Theme';

const Container = styled.View`
  flex: 1;
`;

const App = (props) => {
  const [isLoadingComplete, setLoadingComplete] = useState(false);

  const handleFinishLoading = () => {
    setLoadingComplete(true);
  };

  if (!isLoadingComplete && !props.skipLoadingScreen) {
    return (
      <AppLoading
        startAsync={loadResourcesAsync}
        onError={handleLoadingError}
        onFinish={() => handleFinishLoading(setLoadingComplete)}
      />
    );
  } else {
    return (
      <Theme>
        <Container>
          <AppNavigator />
        </Container>
      </Theme>
    );
  }
};

async function loadResourcesAsync() {
  await Promise.all([
    Asset.loadAsync([
      require('./assets/images/robot-dev.png'),
      require('./assets/images/robot-prod.png')
    ]),
    Font.loadAsync({
      // This is the font that we are using for our tab bar
      ...Ionicons.font,
      // We include SpaceMono because we use it in HomeScreen.js. Feel free to
      // remove this if you are not using it in your app
      'space-mono': require('./assets/fonts/SpaceMono-Regular.ttf')
    })
  ]);
}

function handleLoadingError(error) {
  // In this case, you might want to report the error to your error reporting
  // service, for example Sentry
  console.warn(error);
}

export default App;
