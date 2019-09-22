import React from 'react';
import {Platform, Easing, Animated} from 'react-native';
import {createStackNavigator, createBottomTabNavigator} from 'react-navigation';

import TabBarIcon from '../components/TabBarIcon';
import HomeScreen from '../screens/HomeScreen';
import LearnScreen from '../screens/LearnScreen';
import MoreScreen from '../screens/MoreScreen';
import {theme} from '../components/Theme';
import ItemScreen from '../screens/ItemScreen';
import VeritasScreen from '../screens/More/VeritasScreen';
import AttributionsScreen from '../screens/More/AttributionsScreen';
import TeamScreen from '../screens/More/TeamScreen';
import PenChanceScreen from '../screens/Learn/PenChanceScreen';
import DamageCalcScreen from '../screens/Learn/DamageCalcScreen';
import BallisticsScreen from '../screens/Learn/BallisticsScreen';

const config = Platform.select({
  web: {headerMode: 'screen'},
  default: {}
});

// Moved this so it could be reused
const transitionConfig = () => ({
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
});

const HomeStack = createStackNavigator(
  {
    Home: {screen: HomeScreen, path: 'home'},
    Firearms: {screen: ItemScreen, path: 'firearms'}
  },
  {
    ...config,
    transitionConfig
  }
);

HomeStack.navigationOptions = {
  tabBarLabel: 'Items',
  tabBarIcon: ({focused}) => <TabBarIcon focused={focused} name="items" /> // eslint-disable-line
};

HomeStack.path = '';

const LearnStack = createStackNavigator(
  {
    Learn: LearnScreen,
    PenChance: PenChanceScreen,
    DamageCalc: DamageCalcScreen,
    Ballistics: BallisticsScreen
  },
  {
    ...config,
    transitionConfig
  }
);

LearnStack.navigationOptions = {
  tabBarLabel: 'Learn',
  tabBarIcon: ({focused}) => <TabBarIcon focused={focused} name="learn" /> // eslint-disable-line
};

LearnStack.path = '';

const MoreStack = createStackNavigator(
  {
    More: MoreScreen,
    Veritas: VeritasScreen,
    Team: TeamScreen,
    Attributions: AttributionsScreen
  },
  {
    ...config,
    transitionConfig
  }
);

MoreStack.navigationOptions = {
  tabBarLabel: 'More',
  tabBarIcon: ({focused}) => <TabBarIcon focused={focused} name="more" /> // eslint-disable-line
};

MoreStack.path = '';

const tabNavigator = createBottomTabNavigator(
  {HomeStack, LearnStack, MoreStack},
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
