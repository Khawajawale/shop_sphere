import type { CallableContext } from "firebase-functions/v1/https";
import type { Request } from "express";

/** Normalized callable request for v1 Firebase Functions. */
export interface AppCallableRequest<T = unknown> {
  data: T;
  auth?: CallableContext["auth"];
  rawRequest: Request;
}

export function toCallableRequest<T>(
  data: T,
  context: CallableContext
): AppCallableRequest<T> {
  return {
    data,
    auth: context.auth,
    rawRequest: context.rawRequest,
  };
}
