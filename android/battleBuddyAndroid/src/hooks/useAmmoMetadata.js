import {useGlobalMetadataManager} from '../context/FirebaseProvider';

const useAmmoMetadata = () => {
  const {getGlobalMetadata} = useGlobalMetadataManager();
  const metadata = getGlobalMetadata();

  if (metadata) {
    const ammoMd = metadata.ammoMetadata;

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
