import React from 'react';
import {createStackNavigator} from 'react-navigation-stack';
import MoreScreen from '../screens/MoreScreen';
import TabBarIcon from '../components/common/TabBarIcon';
import VeritasScreen from '../screens/stacks/More/VeritasScreen';
import TeamScreen from '../screens/stacks/More/TeamScreen';
import AttributionsScreen from '../screens/stacks/More/AttributionsScreen';

const moreNavigator = createStackNavigator({
  More: MoreScreen,
  Veritas: VeritasScreen,
  Team: TeamScreen,
  Attributions: AttributionsScreen
});

moreNavigator.navigationOptions = {
  tabBarLabel: 'More',
  tabBarIcon: ({focused}) => <TabBarIcon focused={focused} name="more" /> // eslint-disable-line
};

export default moreNavigator;
