{-# LANGUAGE InstanceSigs #-}

import Control.Monad

data IdentityT m a =
  IdentityT { runIdentityT :: m a } deriving (Eq, Show)

instance Functor m => Functor (IdentityT m) where
  fmap f (IdentityT ma) = IdentityT (fmap f ma)

instance Applicative m => Applicative (IdentityT m) where
  pure = IdentityT . pure

  (IdentityT fab) <*> (IdentityT fa) =
    IdentityT (fab <*> fa)

instance Monad m => Monad (IdentityT m) where
  return = pure

  (>>=) :: IdentityT m a
        -> (a -> IdentityT m b)
        -> IdentityT m b
  (IdentityT ma) >>= f =
    IdentityT $ ma >>= (runIdentityT . f)
