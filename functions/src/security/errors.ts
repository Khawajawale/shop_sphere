import * as functions from "firebase-functions/v1";
import * as logger from "firebase-functions/logger";

import type { AppCallableRequest } from "./callable_types";

/**
 * Logs detailed errors server-side; returns generic messages to clients.
 */
export function handleCallableError(
  error: unknown,
  context: string
): never {
  if (error instanceof functions.https.HttpsError) {
    throw error;
  }

  logger.error(`Callable error [${context}]`, error);

  throw new functions.https.HttpsError(
    "internal",
    "An unexpected error occurred. Please try again."
  );
}

export function requireAuth(request: AppCallableRequest): string {
  if (!request.auth?.uid) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "Login required."
    );
  }
  return request.auth.uid;
}
