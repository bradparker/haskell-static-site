module CMarkGFM.Extended
  ( module CMarkGFM
  ) where

import CMarkGFM
import Data.Aeson (FromJSON, ToJSON)

instance FromJSON ListType
instance ToJSON ListType

instance FromJSON DelimType
instance ToJSON DelimType

instance FromJSON TableCellAlignment
instance ToJSON TableCellAlignment

instance FromJSON ListAttributes
instance ToJSON ListAttributes

instance FromJSON PosInfo
instance ToJSON PosInfo

instance FromJSON NodeType
instance ToJSON NodeType

instance FromJSON Node
instance ToJSON Node
