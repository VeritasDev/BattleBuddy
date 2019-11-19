import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import FirearmDetail from '../../../components/detail/FirearmDetail';
import ArmorDetail from '../../../components/detail/ArmorDetail';
import AmmoDetail from '../../../components/detail/AmmoDetail';
import MedicalDetail from '../../../components/detail/MedicalDetail';
import ThrowableDetail from '../../../components/detail/ThrowableDetail';
import MeleeDetail from '../../../components/detail/MeleeDetail';
import StorageImage from '../../../components/common/StorageImage';
import ImageType from '../../../constants/ImageType';
import ChestRigDetail from '../../../components/detail/ChestRigDetail';
import HelmetDetail from '../../../components/detail/HelmetDetail';
import VisorDetail from '../../../components/detail/VisorDetail';

const ScrollView = styled.ScrollView`
  background: ${({theme}) => theme.colors.background};
`;

const Text = styled.Text`
  color: white;
`;

const View = styled.View`
  /* prettier-ignore */
  aspectRatio: 1.77;
  width: 100%;
`;

const Image = styled(StorageImage)`
  width: 100%;
  height: 100%;
`;

const Description = styled(Text)`
  padding: 20px;
  text-align: justify;
`;

const ItemDetailScreen = ({navigation}) => {
  const {item, type} = navigation.state.params;

  const typeToComponent = {
    firearm: FirearmDetail,
    armor: ArmorDetail,
    ammunition: AmmoDetail,
    medical: MedicalDetail,
    grenade: ThrowableDetail,
    melee: MeleeDetail,
    helmet: HelmetDetail,
    tacticalrig: ChestRigDetail,
    visor: VisorDetail
  };

  const DetailElement = typeToComponent[type];

  return (
    <ScrollView>
      <View>
        <Image doc={item} size={ImageType.large} />
      </View>
      <Description>{item.description}</Description>
      <DetailElement item={item} />
    </ScrollView>
  );
};

ItemDetailScreen.navigationOptions = (screenProps) => ({
  title: screenProps.navigation.getParam('item').name
});

ItemDetailScreen.propTypes = {
  navigation: PropTypes.any.isRequired
};

export default ItemDetailScreen;
