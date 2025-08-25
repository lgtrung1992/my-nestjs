import { BaseModel } from '@/database/models/base.model';
import { Column, Entity } from 'typeorm';

// https://www.better-auth.com/docs/concepts/database#core-schema
@Entity('verifications')
export class VerificationEntity extends BaseModel {
  @Column()
  identifier: string;

  @Column()
  value: string;

  @Column({ type: 'timestamp', name: 'expires_at' })
  expiresAt: Date;
}
