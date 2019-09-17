import React from 'react';
import { Platform, Easing, Animated } from 'react-native';
import {
  createStackNavigator,
  createBottomTabNavigator,
} from 'react-navigation';

import Colors from '../constants/Colors';
import TabBarIcon from '../components/TabBarIcon';
import HomeScreen from '../screens/HomeScreen';
import LinksScreen from '../screens/LinksScreen';
import SettingsScreen from '../screens/SettingsScreen';
import * as Localization from 'expo-localization';
import i18n from 'i18n-js';
import FirearmsScreen from '../screens/ItemScreens/FirearmsScreen';

const config = Platform.select({
  web: { headerMode: 'screen' },
  default: {},
});

const HomeStack = createStackNavigator(
  {
    Home: { screen: HomeScreen, path: 'home' },
    Firearms: { screen: FirearmsScreen, path: 'firearms' },
  },
  {
    ...config,
    // Right to Left transition for transitioning between screens.
    transitionConfig: () => ({
      transitionSpec: {
        duration: 300,
        easing: Easing.out(Easing.poly(4)),
        timing: Animated.timing,
      },
      screenInterpolator: sceneProps => {
        const { layout, position, scene } = sceneProps;
        const { index } = scene;

        const width = layout.initWidth;
        const translateX = position.interpolate({
          inputRange: [index - 1, index, index + 1],
          outputRange: [width, 0, 0],
        });

        const opacity = position.interpolate({
          inputRange: [index - 1, index - 0.99, index],
          outputRange: [0, 1, 1],
        });

        return { opacity, transform: [{ translateX: translateX }] };
      },
    }),
  },
);

HomeStack.navigationOptions = {
  tabBarLabel: 'Items',
  tabBarIcon: ({ focused }) => <TabBarIcon focused={focused} name="items" />,
};

HomeStack.path = '';

const LinksStack = createStackNavigator({ Links: LinksScreen }, config);

LinksStack.navigationOptions = {
  tabBarLabel: 'Learn',
  tabBarIcon: ({ focused }) => <TabBarIcon focused={focused} name="learn" />,
};

LinksStack.path = '';

const SettingsStack = createStackNavigator(
  {
    Settings: SettingsScreen,
  },
  config,
);

SettingsStack.navigationOptions = {
  tabBarLabel: 'More',
  tabBarIcon: ({ focused }) => <TabBarIcon focused={focused} name="more" />,
};

SettingsStack.path = '';

const tabNavigator = createBottomTabNavigator(
  { HomeStack, LinksStack, SettingsStack },
  {
    tabBarOptions: {
      activeTintColor: '#FF491C',
      style: {
        backgroundColor: Colors.tabBar,
      },
    },
  },
);

tabNavigator.path = '';

export default tabNavigator;
