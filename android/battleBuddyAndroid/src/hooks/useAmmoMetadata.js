import {useGlobalMetadataManager} from '../context/FirebaseProvider';

const useAmmoMetadata = () => {
  const {globalMetadata} = useGlobalMetadataManager();

  if (globalMetadata) {
    const ammoMd = globalMetadata.ammoMetadata;

    const sorted = [];
    Object.entries(ammoMd)
      .map(([key, prop]) => ({
        ...prop,
        name: key
      }))
      .map(({index, ...x}) => (sorted[index] = x));
    return sorted;
  }
};

export default useAmmoMetadata;
