import { useMatches } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

const useBreadcrumbs = (): { label: string; path: string }[] => {
  const { t } = useTranslation();
  const matches = useMatches();

  return matches
    .filter((match: any) => Boolean(match?.handle?.breadcrumb))
    .map((match) => ({
      label:
        typeof match.handle.breadcrumb.label === 'function'
          ? match.handle.breadcrumb.label({ ...match.params })
          : t(match.handle.breadcrumb.label, { ns: match.handle.breadcrumb.ns }),
      path: match.handle.breadcrumb?.path ?? match.pathname,
    }));
};

export default useBreadcrumbs;
