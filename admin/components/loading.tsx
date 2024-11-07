import React from 'react';

const Loading: React.FC = () => {
  return (
    <div className="flex items-center justify-center py-10">
      <div className="h-8 w-8 animate-spin rounded-full border-b-2 border-t-2 border-gray-900"></div>
      <span className="ml-3 text-gray-600">Loading...</span>
    </div>
  );
};

export default Loading;
