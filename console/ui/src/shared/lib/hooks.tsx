import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { toast } from 'react-toastify';

/**
 * Hook polls RTK query request every N seconds.
 * @param request - RTK request to poll.
 * @param pollingInterval - Number in milliseconds that represents polling interval.
 * @param options - Different config options.
 */
export const useQueryPolling = (request: any, pollingInterval: number, options?: { stop?: boolean }) => {
  const result = request();

  useEffect(() => {
    const polling = setInterval(() => result.refetch(), pollingInterval);
    if (options?.stop?.toString() === 'true') clearInterval(polling);
    return () => {
      clearInterval(polling);
    };
  }, [options]);

  return result;
};

/**
 * Custom hook for copying value to clipboard. Returns copied value and function to copy value.
 */
export const useCopyToClipboard = (): [copiedText: string | null, copyFunction: (text: string) => Promise<boolean>] => {
  const { t } = useTranslation('toasts');
  const [copiedText, setCopiedText] = useState(null);

  const copyFunction = async (text) => {
    try {
      if (navigator.clipboard && window.isSecureContext) {
        await navigator.clipboard.writeText(text);
      } else {
        const textArea = document.createElement('textarea');
        textArea.value = text;
        textArea.style.position = 'fixed';
        textArea.style.left = '-999999px';
        textArea.style.top = '-999999px';
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        document.execCommand('copy');
        textArea.remove();
      }
      setCopiedText(text);
      toast.success(t('valueCopiedToClipboard'));
      return true;
    } catch (error) {
      console.warn('Copy failed', error);
      toast.error(t('failedToCopyToClipboard'));
      setCopiedText(null);
      return false;
    }
  };

  return [copiedText, copyFunction];
};
