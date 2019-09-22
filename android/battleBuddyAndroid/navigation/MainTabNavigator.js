import React from 'react';
import {Platform, Easing, Animated} from 'react-native';
import {createStackNavigator, createBottomTabNavigator} from 'react-navigation';

import TabBarIcon from '../components/TabBarIcon';
import HomeScreen from '../screens/HomeScreen';
import LinksScreen from '../screens/LinksScreen';
import MoreScreen from '../screens/MoreScreen';
import {theme} from '../components/Theme';
import ItemScreen from '../screens/ItemScreen';
import VeritasScreen from '../screens/More/VeritasScreen';
import AttributionsScreen from '../screens/More/AttributionsScreen';
import TeamScreen from '../screens/More/TeamScreen';

const config = Platform.select({
  web: {headerMode: 'screen'},
  default: {}
});

const HomeStack = createStackNavigator(
  {
    Home: {screen: HomeScreen, path: 'home'},
    Firearms: {screen: ItemScreen, path: 'firearms'}
  },
  {
    ...config,
    // Right to Left transition for transitioning between screens.
    transitionConfig: () => ({
      transitionSpec: {
        duration: 300,
        easing: Easing.out(Easing.poly(4)),
        timing: Animated.timing
      },
      screenInterpolator: (sceneProps) => {
        const {layout, position, scene} = sceneProps;
        const {index} = scene;

        const width = layout.initWidth;
        const translateX = position.interpolate({
          inputRange: [index - 1, index, index + 1],
          outputRange: [width, 0, 0]
        });

        const opacity = position.interpolate({
          inputRange: [index - 1, index - 0.99, index],
          outputRange: [0, 1, 1]
        });

        return {opacity, transform: [{translateX: translateX}]};
      }
    })
  }
);

HomeStack.navigationOptions = {
  tabBarLabel: 'Items',
  tabBarIcon: ({focused}) => <TabBarIcon focused={focused} name="items" /> // eslint-disable-line
};

HomeStack.path = '';

const LinksStack = createStackNavigator({Links: LinksScreen}, config);

LinksStack.navigationOptions = {
  tabBarLabel: 'Learn',
  tabBarIcon: ({focused}) => <TabBarIcon focused={focused} name="learn" /> // eslint-disable-line
};

LinksStack.path = '';

const MoreStack = createStackNavigator(
  {
    More: MoreScreen,
    Veritas: VeritasScreen,
    Team: TeamScreen,
    Attributions: AttributionsScreen
  },
  {
    ...config
  }
);

MoreStack.navigationOptions = {
  tabBarLabel: 'More',
  tabBarIcon: ({focused}) => <TabBarIcon focused={focused} name="more" /> // eslint-disable-line
};

MoreStack.path = '';

const tabNavigator = createBottomTabNavigator(
  {HomeStack, LinksStack, MoreStack},
  {
    tabBarOptions: {
      activeTintColor: theme.colors.orange,
      style: {
        backgroundColor: theme.colors.almostBlack
      }
    }
  }
);

tabNavigator.path = '';

export default tabNavigator;
