import React, {useEffect, useState} from 'react';
import styled from 'styled-components/native';
import {FlatList} from 'react-native';
import AmmunitionProvider, {
  useAmmunition
} from '../../../context/AmmunitionProvider';
import LoadingIndicator from '../../../components/common/LoadingIndicator';
import {useBallistics} from '../../../context/BallisticsProvider';
import {useNavigation} from 'react-navigation-hooks';

const View = styled.View`
  background: ${({theme}) => theme.colors.almostBlack};
  flex: 1;
`;

const Header = styled.View`
  background: ${({theme}) => theme.colors.black};
  display: flex;
  flex-direction: row;
  padding: 20px 0;
`;

const HeaderText = styled.Text`
  color: ${({active}) => (active ? 'white' : 'rgba(255, 255, 255, 0.5)')};
  text-align: center;
  width: 25%;
`;

const ItemText = styled.Text`
  color: white;
  text-align: center;
  width: 25%;
  padding: 14px 0;
`;

const ListItem = styled.TouchableOpacity`
  display: flex;
  flex-direction: row;
  align-items: center;
  text-align: center;
  border-bottom-color: rgba(255, 255, 255, 0.1);
  border-bottom-width: 1px;
`;

const AmmoTableScreen = () => {
  const {setAmmo} = useBallistics();
  const navigation = useNavigation();
  const {loading, data, getAllAmmo} = useAmmunition();
  const [sorted, setSorted] = useState({
    data: null,
    type: null,
    direction: 'ASC'
  });

  useEffect(() => {
    getAllAmmo();
  }, []);

  useEffect(() => {
    if (data) {
      sortByType('penetration', 'DESC');
    }
  }, [data]);

  if (loading) return <LoadingIndicator />;

  const onPressHandler = (item) => {
    setAmmo(item);
    navigation.goBack();
  };

  const sortByType = (type, direction) => {
    let sorted;

    if (direction === 'ASC') {
      sorted = data.sort((a, b) => {
        if (typeof a[type] === 'string') {
          return a[type].localeCompare(b[type]);
        } else {
          return a[type] - b[type];
        }
      });
    } else {
      sorted = data.sort((a, b) => {
        if (typeof a[type] === 'string') {
          return b[type].localeCompare(a[type]);
        } else {
          return b[type] - a[type];
        }
      });
    }

    setSorted({type, data: sorted, direction});
  };

  const types = [
    {label: 'Name', type: 'shortName'},
    {label: 'Caliber', type: 'caliber'},
    {label: 'Penetration', type: 'penetration'},
    {label: 'Damage', type: 'damage'}
  ];

  return (
    <View>
      <Header>
        {types.map((x) => (
          <HeaderText
            key={x.type}
            onPress={() =>
              sortByType(x.type, sorted.direction === 'ASC' ? 'DESC' : 'ASC')
            }
            active={sorted.type === x.type}
          >
            {x.label}
          </HeaderText>
        ))}
      </Header>
      <FlatList
        data={sorted.data || data}
        keyExtractor={(item) => item._id}
        renderItem={({item}) => (
          <ListItem onPress={() => onPressHandler(item)}>
            <ItemText>{item.shortName}</ItemText>
            <ItemText>{item.caliber}</ItemText>
            <ItemText>{item.penetration}</ItemText>
            <ItemText>{item.damage}</ItemText>
          </ListItem>
        )}
      />
    </View>
  );
};

const Wrapper = () => (
  <AmmunitionProvider>
    <AmmoTableScreen />
  </AmmunitionProvider>
);

Wrapper.navigationOptions = {
  title: 'Ammunition'
};

export default Wrapper;
