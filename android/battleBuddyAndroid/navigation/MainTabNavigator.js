import React from 'react';
import { Platform } from 'react-native';
import { createStackNavigator, createBottomTabNavigator } from 'react-navigation';

import Colors from '../constants/Colors';
import TabBarIcon from '../components/TabBarIcon';
import HomeScreen from '../screens/HomeScreen';
import LinksScreen from '../screens/LinksScreen';
import SettingsScreen from '../screens/SettingsScreen';
import * as Localization from 'expo-localization';
import i18n from 'i18n-js';

const config = Platform.select({
  web: { headerMode: 'screen' },
  default: {},
});

const HomeStack = createStackNavigator( { 
  Home: HomeScreen
}, config );

HomeStack.navigationOptions = {
  tabBarLabel: 'Items',  
  tabBarIcon: ({ focused }) => ( <TabBarIcon focused={focused} name={'items'}/> ),
};

HomeStack.path = '';

const LinksStack = createStackNavigator( { Links: LinksScreen }, config );

LinksStack.navigationOptions = {
  tabBarLabel: 'Learn',
  tabBarIcon: ({ focused }) => ( <TabBarIcon focused={focused} name={'learn'} /> ),
};

LinksStack.path = '';

const SettingsStack = createStackNavigator(
  {
    Settings: SettingsScreen,
  },
  config
);

SettingsStack.navigationOptions = {
  tabBarLabel: 'More',
  tabBarIcon: ({ focused }) => ( <TabBarIcon focused={focused} name={'more'} /> ),
};

SettingsStack.path = '';

const tabNavigator = createBottomTabNavigator({ HomeStack, LinksStack, SettingsStack },
  {
    tabBarOptions: {
      activeTintColor: '#FF491C',
      style: {
        backgroundColor: Colors.tabBar,
      }
    } 
  }
);

tabNavigator.path = '';

export default tabNavigator;
